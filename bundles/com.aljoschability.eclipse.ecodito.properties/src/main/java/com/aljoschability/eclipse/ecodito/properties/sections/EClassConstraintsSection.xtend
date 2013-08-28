package com.aljoschability.eclipse.ecodito.properties.sections;

import com.aljoschability.core.ui.CoreImages
import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import java.util.Collections
import java.util.LinkedHashMap
import java.util.Map
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.emf.transaction.TransactionalEditingDomain
import org.eclipse.jface.layout.GridDataFactory
import org.eclipse.jface.layout.GridLayoutFactory
import org.eclipse.jface.resource.JFaceResources
import org.eclipse.jface.viewers.ArrayContentProvider
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.ISelectionChangedListener
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.jface.viewers.SelectionChangedEvent
import org.eclipse.jface.viewers.TableViewer
import org.eclipse.jface.viewers.ViewerComparator
import org.eclipse.ocl.examples.xtext.console.XtextConsolePlugin
import org.eclipse.ocl.examples.xtext.console.xtfo.EmbeddedXtextEditor
import org.eclipse.ocl.examples.xtext.essentialocl.ui.model.BaseDocument
import org.eclipse.ocl.examples.xtext.essentialocl.utilities.EssentialOCLCSResource
import org.eclipse.ocl.examples.xtext.essentialocl.utilities.EssentialOCLPlugin
import org.eclipse.swt.SWT
import org.eclipse.swt.custom.SashForm
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.FormAttachment
import org.eclipse.swt.layout.FormData
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.ui.ISharedImages
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.views.properties.tabbed.TabbedPropertySheetWidgetFactory

import static com.aljoschability.eclipse.ecodito.properties.sections.EClassConstraintsSection.*
import com.aljoschability.eclipse.core.properties.sections.AbstractPropertySection

class EClassConstraintsSection extends AbstractPropertySection {
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

	new() {
		super(GraphitiElementAdapter.get());
		constraints = new LinkedHashMap<String, String>();
	}

	override protected createWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {
		sash = new SashForm(parent, SWT.HORIZONTAL);

		// wrapped constraints part
		constraintsWrapper = factory.createFlatFormComposite(sash);
		createConstraintsWidgets(constraintsWrapper, factory);

		// wrapped expression part
		expressionWrapper = factory.createFlatFormComposite(sash);
		createExpressionWidgets(expressionWrapper, factory);

		sash.setWeights(#{1, 2});
	}

	def private void createConstraintsWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {

		// group
		constraintsGroup = factory.createGroup(parent, "Constraints");

		// buttons composite
		constraintsButtonComposite = factory.createFlatFormComposite(constraintsGroup);

		// remove button
		constraintsRemoveButton = factory.createButton(constraintsButtonComposite, EMPTY, SWT.PUSH);
		val sharedImages = PlatformUI.getWorkbench().getSharedImages();
		constraintsRemoveButton.setImage(sharedImages.getImage(ISharedImages.IMG_ETOOL_DELETE));
		constraintsRemoveButton.setToolTipText("Remove Selected Constraint");
		constraintsRemoveButton.setEnabled(false);
		constraintsRemoveButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					handleRemoveConstraint();
				}
			});

		// add button
		constraintsAddButton = factory.createButton(constraintsButtonComposite, EMPTY, SWT.PUSH);
		constraintsAddButton.setImage(CoreImages.get(CoreImages.ADD));
		constraintsAddButton.setToolTipText("Add New Constraint");
		constraintsAddButton.addSelectionListener(
			new SelectionAdapter() {
				override widgetSelected(SelectionEvent e) {
					handleAddConstraint();
				}
			});

		// actual table
		constraintsTableWrapper = factory.createFlatFormComposite(constraintsGroup);

		val table = factory.createTable(constraintsTableWrapper, SWT.BORDER.bitwiseOr(SWT.SINGLE));
		table.setLinesVisible(true);

		constraintsViewer = new TableViewer(table);
		constraintsViewer.setContentProvider(new ArrayContentProvider());
		constraintsViewer.setLabelProvider(new LabelProvider());
		constraintsViewer.setComparator(new ViewerComparator());
		constraintsViewer.addSelectionChangedListener(
			new ISelectionChangedListener() {
				override selectionChanged(SelectionChangedEvent event) {
					handleConstraintSelected();
				}
			});
	}

	override setInput(IWorkbenchPart part, ISelection selection) {
		super.setInput(part, selection);

		readConstraints();
		constraintsViewer.setInput(constraints.keySet());

		val document = expressionEditor.getDocument() as BaseDocument;
		val Map<String, EClassifier> parameters = Collections.emptyMap();

		val uri = document.getResourceURI();
		val resource = document.getResourceSet().getResource(uri, true) as EssentialOCLCSResource;
		document.setContext(resource, getElement(), parameters);
	}

	def private void readConstraints() {
		constraints.clear();

		var annotation = getElement().getEAnnotation(SOURCE_OCL);
		if (annotation != null) {
			val details = annotation.getDetails();
			for (String key : details.keySet()) {
				constraints.put(key, details.get(key));
			}
		}
	}

	def protected void handleConstraintSelected() {
		val selection = constraintsViewer.getSelection() as IStructuredSelection;

		// set input for expression editor
		if (selection.isEmpty()) {
			val text = expressionEditor.getViewer().getTextWidget();
			text.setEnabled(false);
			return;
		}
		val constraintKey = selection.getFirstElement() as String;
		var value = constraints.get(constraintKey);
		if (value == null) {
			value = EMPTY;
		}

		expressionEditor.getDocument().set(value);
		val text = expressionEditor.getViewer().getTextWidget();
		text.setEnabled(true);

		// set remove button state
		constraintsRemoveButton.setEnabled(!selection.isEmpty());
	}

	def protected void handleRemoveConstraint() {
		val command = new RecordingCommand(getEditingDomain() as TransactionalEditingDomain) {
			override protected doExecute() {
				val selection = constraintsViewer.getSelection() as IStructuredSelection;
				if (selection.size() == 1) {
					val annotation = getElement().getEAnnotation(SOURCE_OCL);
					if (annotation != null) {
						val key = selection.getFirstElement() as String;
						val index = annotation.getDetails().indexOfKey(key);
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

	def protected void handleAddConstraint() {

		// create command
		val command = new RecordingCommand(getEditingDomain() as TransactionalEditingDomain) {
			override protected doExecute() {

				// OCL annotation
				var oclAnnotation = getElement().getEAnnotation(SOURCE_OCL);
				if (oclAnnotation == null) {
					oclAnnotation = EcoreFactory.eINSTANCE.createEAnnotation();
					oclAnnotation.setSource(SOURCE_OCL);

					// append command to add the OCL annotation
					getElement().getEAnnotations().add(oclAnnotation);
				}

				// search valid name
				val details = oclAnnotation.getDetails();
				val prefix = "Constraint";
				var index = 0;
				var name = prefix + index;
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

	override protected EClass getElement() {
		return super.getElement() as EClass;
	}

	def private void createExpressionWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {

		// group
		expressionGroup = factory.createGroup(expressionWrapper, "Expression");

		// wrapper
		expressionEditorWrapper = factory.createComposite(expressionGroup, SWT.BORDER);

		// editor
		val injector = XtextConsolePlugin.getInstance().getInjector(EssentialOCLPlugin.LANGUAGE_ID);

		val style = SWT.BORDER.bitwiseOr(SWT.MULTI).bitwiseOr(SWT.V_SCROLL);
		expressionEditor = new EmbeddedXtextEditor(expressionEditorWrapper, injector, style);

		val text = expressionEditor.getViewer().getTextWidget();
		text.setEnabled(false);
		text.setFont(JFaceResources.getFont(JFaceResources.TEXT_FONT));

		// do it less often
		text.addModifyListener(
			[ e |
				val command = new RecordingCommand(getEditingDomain() as TransactionalEditingDomain) {
					override protected doExecute() {
						val selection = constraintsViewer.getSelection() as IStructuredSelection;

						val key = selection.getFirstElement() as String;
						val value = expressionEditor.getDocument().get();
						getElement().getEAnnotation(SOURCE_OCL).getDetails().put(key, value);
					}
				};
				execute(command);
			]);
	}

	override protected void layoutWidgets() {
		var m = SIZE_MARGIN;

		// sash
		var data = new FormData();
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

	override shouldUseExtraSpace() {
		return true;
	}
}
