package com.aljoschability.eclipse.ecodito.properties;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

import org.eclipse.emf.common.command.Command;
import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EAnnotation;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.transaction.RecordingCommand;
import org.eclipse.emf.transaction.TransactionalEditingDomain;
import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.layout.GridLayoutFactory;
import org.eclipse.jface.resource.JFaceResources;
import org.eclipse.jface.viewers.ArrayContentProvider;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.ISelectionChangedListener;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.jface.viewers.SelectionChangedEvent;
import org.eclipse.jface.viewers.TableViewer;
import org.eclipse.jface.viewers.ViewerComparator;
import org.eclipse.ocl.examples.xtext.console.XtextConsolePlugin;
import org.eclipse.ocl.examples.xtext.console.xtfo.EmbeddedXtextEditor;
import org.eclipse.ocl.examples.xtext.essentialocl.ui.model.BaseDocument;
import org.eclipse.ocl.examples.xtext.essentialocl.utilities.EssentialOCLCSResource;
import org.eclipse.ocl.examples.xtext.essentialocl.utilities.EssentialOCLPlugin;
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.SashForm;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FormAttachment;
import org.eclipse.swt.layout.FormData;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Table;
import org.eclipse.ui.ISharedImages;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.views.properties.tabbed.TabbedPropertySheetWidgetFactory;

import com.aljoschability.core.ui.CoreImages;
import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractPropertySection;
import com.google.inject.Injector;

public class EClassConstraintsSection extends AbstractPropertySection {
	private static final String SOURCE_OCL = "http://www.eclipse.org/emf/2002/Ecore/OCL";

	private SashForm sash;

	private Group constraintsGroup;
	private TableViewer constraintsViewer;

	private Group expressionGroup;
	private EmbeddedXtextEditor expressionEditor;

	private Composite expressionWrapper;

	private Composite constraintsWrapper;

	private Button constraintsAddButton;

	private Composite constraintsButtonComposite;

	private Button constraintsRemoveButton;

	private Composite constraintsTableWrapper;

	private Map<String, String> constraints;

	private Composite expressionEditorWrapper;

	public EClassConstraintsSection() {
		super(GraphitiElementAdapter.get());
		constraints = new LinkedHashMap<String, String>();
	}

	@Override
	protected void createWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {
		sash = new SashForm(parent, SWT.HORIZONTAL);

		// wrapped constraints part
		constraintsWrapper = factory.createFlatFormComposite(sash);
		createConstraintsWidgets(constraintsWrapper, factory);

		// wrapped expression part
		expressionWrapper = factory.createFlatFormComposite(sash);
		createExpressionWidgets(expressionWrapper, factory);

		sash.setWeights(new int[] { 1, 2 });
	}

	private void createConstraintsWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {
		// group
		constraintsGroup = factory.createGroup(parent, "Constraints");

		// buttons composite
		constraintsButtonComposite = factory.createFlatFormComposite(constraintsGroup);

		// remove button
		constraintsRemoveButton = factory.createButton(constraintsButtonComposite, EMPTY, SWT.PUSH);
		ISharedImages sharedImages = PlatformUI.getWorkbench().getSharedImages();
		constraintsRemoveButton.setImage(sharedImages.getImage(ISharedImages.IMG_ETOOL_DELETE));
		constraintsRemoveButton.setToolTipText("Remove Selected Constraint");
		constraintsRemoveButton.setEnabled(false);
		constraintsRemoveButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				handleRemoveConstraint();
			}
		});

		// add button
		constraintsAddButton = factory.createButton(constraintsButtonComposite, EMPTY, SWT.PUSH);
		constraintsAddButton.setImage(CoreImages.get(CoreImages.ADD));
		constraintsAddButton.setToolTipText("Add New Constraint");
		constraintsAddButton.addSelectionListener(new SelectionAdapter() {
			@Override
			public void widgetSelected(SelectionEvent e) {
				handleAddConstraint();
			}
		});

		// actual table
		constraintsTableWrapper = factory.createFlatFormComposite(constraintsGroup);

		Table table = factory.createTable(constraintsTableWrapper, SWT.BORDER | SWT.SINGLE);
		table.setLinesVisible(true);

		constraintsViewer = new TableViewer(table);
		constraintsViewer.setContentProvider(new ArrayContentProvider());
		constraintsViewer.setLabelProvider(new LabelProvider());
		constraintsViewer.setComparator(new ViewerComparator());
		constraintsViewer.addSelectionChangedListener(new ISelectionChangedListener() {
			@Override
			public void selectionChanged(SelectionChangedEvent event) {
				handleConstraintSelected();
			}
		});
	}

	@Override
	public void setInput(IWorkbenchPart part, ISelection selection) {
		super.setInput(part, selection);

		readConstraints();
		constraintsViewer.setInput(constraints.keySet());

		BaseDocument document = (BaseDocument) expressionEditor.getDocument();
		Map<String, EClassifier> parameters = Collections.emptyMap();

		URI uri = document.getResourceURI();
		EssentialOCLCSResource resource = (EssentialOCLCSResource) document.getResourceSet().getResource(uri, true);
		document.setContext(resource, getElement(), parameters);
	}

	private void readConstraints() {
		constraints.clear();

		EAnnotation annotation = getElement().getEAnnotation(SOURCE_OCL);
		if (annotation != null) {
			EMap<String, String> details = annotation.getDetails();
			for (String key : details.keySet()) {
				constraints.put(key, details.get(key));
			}
		}
	}

	protected void handleConstraintSelected() {
		IStructuredSelection selection = (IStructuredSelection) constraintsViewer.getSelection();

		// set input for expression editor
		if (selection.isEmpty()) {
			StyledText text = expressionEditor.getViewer().getTextWidget();
			text.setEnabled(false);
			return;
		}
		String constraintKey = (String) selection.getFirstElement();
		String value = constraints.get(constraintKey);
		if (value == null) {
			value = EMPTY;
		}

		expressionEditor.getDocument().set(value);
		StyledText text = expressionEditor.getViewer().getTextWidget();
		text.setEnabled(true);

		// set remove button state
		constraintsRemoveButton.setEnabled(!selection.isEmpty());
	}

	protected void handleRemoveConstraint() {
		Command command = new RecordingCommand((TransactionalEditingDomain) getEditingDomain()) {
			@Override
			protected void doExecute() {
				IStructuredSelection selection = (IStructuredSelection) constraintsViewer.getSelection();
				if (selection.size() == 1) {
					EAnnotation annotation = getElement().getEAnnotation(SOURCE_OCL);
					if (annotation != null) {
						String key = (String) selection.getFirstElement();
						int index = annotation.getDetails().indexOfKey(key);
						if (index != -1) {
							annotation.getDetails().remove(index);
						}
					}
				}
			}
		};

		// execute it
		execute(command);

		// refresh table
		readConstraints();
		constraintsViewer.refresh();
	}

	protected void handleAddConstraint() {
		// create command
		Command command = new RecordingCommand((TransactionalEditingDomain) getEditingDomain()) {
			@Override
			protected void doExecute() {
				// OCL annotation
				EAnnotation oclAnnotation = getElement().getEAnnotation(SOURCE_OCL);
				if (oclAnnotation == null) {
					oclAnnotation = EcoreFactory.eINSTANCE.createEAnnotation();
					oclAnnotation.setSource(SOURCE_OCL);

					// append command to add the OCL annotation
					getElement().getEAnnotations().add(oclAnnotation);
				}

				// search valid name
				EMap<String, String> details = oclAnnotation.getDetails();
				String prefix = "Constraint";
				int index = 0;
				String name = prefix + index;
				while (details.containsKey(name)) {
					index++;
					name = prefix + index;
				}

				// add entry
				details.put(name, EMPTY);
			}
		};

		// execute it
		execute(command);

		// refresh viewer
		readConstraints();
		constraintsViewer.refresh();
	}

	@Override
	protected EClass getElement() {
		return (EClass) super.getElement();
	}

	private void createExpressionWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {
		// group
		expressionGroup = factory.createGroup(expressionWrapper, "Expression");

		// wrapper
		expressionEditorWrapper = factory.createComposite(expressionGroup, SWT.BORDER);

		// editor
		Injector injector = XtextConsolePlugin.getInstance().getInjector(EssentialOCLPlugin.LANGUAGE_ID);

		int style = SWT.BORDER | SWT.MULTI | SWT.V_SCROLL;
		expressionEditor = new EmbeddedXtextEditor(expressionEditorWrapper, injector, style);

		StyledText text = expressionEditor.getViewer().getTextWidget();
		text.setEnabled(false);
		text.setFont(JFaceResources.getFont(JFaceResources.TEXT_FONT));

		// do it less often
		text.addModifyListener(new ModifyListener() {
			@Override
			public void modifyText(ModifyEvent e) {
				RecordingCommand command = new RecordingCommand((TransactionalEditingDomain) getEditingDomain()) {
					@Override
					protected void doExecute() {
						IStructuredSelection selection = (IStructuredSelection) constraintsViewer.getSelection();

						String key = (String) selection.getFirstElement();
						String value = expressionEditor.getDocument().get();
						getElement().getEAnnotation(SOURCE_OCL).getDetails().put(key, value);
					}
				};
				execute(command);
			}
		});
	}

	@Override
	protected void layoutWidgets() {
		int m = SIZE_MARGIN;

		// sash
		FormData data = new FormData();
		data.left = new FormAttachment(0);
		data.right = new FormAttachment(100);
		data.top = new FormAttachment(0);
		data.bottom = new FormAttachment(100);
		sash.setLayoutData(data);

		// constraints
		GridLayoutFactory.fillDefaults().margins(m, 0).applyTo(constraintsWrapper);
		GridLayoutFactory.fillDefaults().spacing(0, 0).margins(m, 0).applyTo(constraintsGroup);
		GridDataFactory.fillDefaults().grab(true, true).applyTo(constraintsGroup);

		// constraints buttons
		GridLayoutFactory.fillDefaults().numColumns(2).applyTo(constraintsButtonComposite);
		GridDataFactory.fillDefaults().align(SWT.TRAIL, SWT.CENTER).applyTo(constraintsButtonComposite);

		// constraints table
		GridLayoutFactory.fillDefaults().margins(0, m).applyTo(constraintsTableWrapper);
		GridDataFactory.fillDefaults().grab(true, true).applyTo(constraintsTableWrapper);
		GridDataFactory.fillDefaults().grab(true, true).applyTo(constraintsViewer.getControl());

		// expression
		GridLayoutFactory.fillDefaults().margins(m, 0).applyTo(expressionWrapper);
		GridLayoutFactory.fillDefaults().margins(m, m).applyTo(expressionGroup);
		GridDataFactory.fillDefaults().grab(true, true).applyTo(expressionGroup);
		GridDataFactory.fillDefaults().grab(true, true).applyTo(expressionEditorWrapper);
		GridLayoutFactory.fillDefaults().applyTo(expressionEditorWrapper);

		GridDataFactory.fillDefaults().grab(true, true).applyTo(expressionEditor.getControl());
	}

	@Override
	public boolean shouldUseExtraSpace() {
		return true;
	}
}
