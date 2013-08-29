package com.aljoschability.eclipse.ecodito.properties.sections;

import com.aljoschability.eclipse.core.properties.State
import com.aljoschability.eclipse.core.properties.graphiti.GraphitiElementAdapter
import com.aljoschability.eclipse.core.properties.sections.AbstractTextSection
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.jdt.core.IPackageFragmentRoot
import org.eclipse.jdt.core.JavaCore
import org.eclipse.jdt.core.search.SearchEngine
import org.eclipse.jdt.internal.corext.refactoring.StubTypeContext
import org.eclipse.jdt.internal.corext.refactoring.TypeContextChecker
import org.eclipse.jdt.internal.ui.dialogs.TextFieldNavigationHandler
import org.eclipse.jdt.internal.ui.refactoring.contentassist.CompletionContextRequestor
import org.eclipse.jdt.internal.ui.refactoring.contentassist.ControlContentAssistHelper
import org.eclipse.jdt.internal.ui.refactoring.contentassist.JavaTypeCompletionProcessor
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.views.properties.tabbed.TabbedPropertySheetWidgetFactory

class EClassifierInstanceClassNameSection extends AbstractTextSection {
	new() {
		super(GraphitiElementAdapter.get());
	}

	override protected getFeature() {
		return EcorePackage.Literals.ECLASSIFIER__INSTANCE_CLASS_NAME;
	}

	override protected validate(String value) {
		return State.info("The java class that this class represents.");
	}

	override protected createWidgets(Composite parent, TabbedPropertySheetWidgetFactory factory) {
		super.createWidgets(parent, factory);

		// install java type completion processor
		val completor = new JavaTypeCompletionProcessor(true, false, true);
		completor.setCompletionContextRequestor(
			new CompletionContextRequestor() {
				private StubTypeContext context;

				override getStubTypeContext() {
					if (context == null) {
						val root = ResourcesPlugin.getWorkspace().getRoot();
						val uri = getElement().eResource().getURI();
						val project = root.getProject(uri.segment(1));

						try {
							if (project.isNatureEnabled(JavaCore.NATURE_ID)) {

								// package
								val javaProject = JavaCore.create(project);

								val javaScope = SearchEngine.createWorkspaceScope();

								// type
								val typeName = JavaTypeCompletionProcessor.DUMMY_CLASS_NAME;

								// TODO: get one "existing" package
								val resource = root.findMember(
									project.getFullPath().addTrailingSeparator().append("src"));
								val theRoot = javaProject.getPackageFragmentRoot(resource);
								for (IPackageFragmentRoot aroot : javaProject.getPackageFragmentRoots()) {
									System.out.println("cannot decide between package fragment root: " + aroot);
								}

								val packageFragment = theRoot.getPackageFragment("");

								context = TypeContextChecker.
									createSuperClassStubTypeContext(typeName, null, packageFragment);
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

	override protected postExecute() {
		refreshTitle();
	}
}
