package com.aljoschability.eclipse.grecoto.ui.properties;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.IPackageFragment;
import org.eclipse.jdt.core.IPackageFragmentRoot;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.search.IJavaSearchScope;
import org.eclipse.jdt.core.search.SearchEngine;
import org.eclipse.jdt.internal.corext.refactoring.StubTypeContext;
import org.eclipse.jdt.internal.corext.refactoring.TypeContextChecker;
import org.eclipse.jdt.internal.ui.dialogs.TextFieldNavigationHandler;
import org.eclipse.jdt.internal.ui.refactoring.contentassist.CompletionContextRequestor;
import org.eclipse.jdt.internal.ui.refactoring.contentassist.ControlContentAssistHelper;
import org.eclipse.jdt.internal.ui.refactoring.contentassist.JavaTypeCompletionProcessor;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.ui.views.properties.tabbed.TabbedPropertySheetWidgetFactory;

import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter;
import com.aljoschability.eclipse.core.ui.properties.State;
import com.aljoschability.eclipse.core.ui.properties.sections.AbstractTextSection;

public class EClassifierInstanceClassNameSection extends AbstractTextSection {
	public EClassifierInstanceClassNameSection() {
		super(GraphitiElementAdapter.get());
	}

	@Override
	protected EStructuralFeature getFeature() {
		return EcorePackage.Literals.ECLASSIFIER__INSTANCE_CLASS_NAME;
	}

	@Override
	protected State validate(String value) {
		return State.info("The java class that this class represents.");
	}

	@Override
	protected void createWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {
		super.createWidgets(parent, factory);

		// install java type completion processor
		JavaTypeCompletionProcessor completor = new JavaTypeCompletionProcessor(true, false, true);
		completor.setCompletionContextRequestor(new CompletionContextRequestor() {
			private StubTypeContext context;

			@Override
			public StubTypeContext getStubTypeContext() {
				if (context == null) {
					IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
					URI uri = getElement().eResource().getURI();
					IProject project = root.getProject(uri.segment(1));

					try {
						if (project.isNatureEnabled(JavaCore.NATURE_ID)) {
							// package
							IJavaProject javaProject = JavaCore.create(project);

							IJavaSearchScope javaScope = SearchEngine.createWorkspaceScope();

							// type
							String typeName = JavaTypeCompletionProcessor.DUMMY_CLASS_NAME;

							// TODO: get one "existing" package
							IResource resource = root.findMember(project.getFullPath().addTrailingSeparator()
									.append("src"));
							IPackageFragmentRoot theRoot = javaProject.getPackageFragmentRoot(resource);
							for (IPackageFragmentRoot aroot : javaProject.getPackageFragmentRoots()) {
								System.out.println("cannot decide between package fragment root: " + aroot);
							}

							IPackageFragment packageFragment = theRoot.getPackageFragment("");

							context = TypeContextChecker.createSuperClassStubTypeContext(typeName, null,
									packageFragment);
						}
					} catch (CoreException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				return context;
			}
		});

		ControlContentAssistHelper.createTextContentAssistant(text, completor);
		TextFieldNavigationHandler.install(text);
	}

	@Override
	protected void postExecute() {
		refreshTitle();
	}
}
