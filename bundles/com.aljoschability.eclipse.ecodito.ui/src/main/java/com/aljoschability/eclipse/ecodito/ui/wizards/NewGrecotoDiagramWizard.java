package com.aljoschability.eclipse.ecodito.ui.wizards;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.Collections;

import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.emf.codegen.ecore.genmodel.GenModelFactory;
import org.eclipse.emf.codegen.ecore.genmodel.GenPackage;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.graphiti.mm.pictograms.Diagram;
import org.eclipse.graphiti.mm.pictograms.PictogramLink;
import org.eclipse.graphiti.mm.pictograms.PictogramsFactory;
import org.eclipse.graphiti.services.Graphiti;
import org.eclipse.jface.operation.IRunnableWithProgress;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.Wizard;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.dialogs.WizardNewFileCreationPage;

import com.aljoschability.eclipse.ecodito.EcoditoConstants;
import com.aljoschability.eclipse.ecodito.ui.GrecotoImages;

public class NewGrecotoDiagramWizard extends Wizard implements INewWizard {
	private IStructuredSelection selection;

	private WizardNewFileCreationPage diagramFilePage;
	private WizardNewFileCreationPage ecoreFilePage;
	private WizardNewFileCreationPage genmodelFilePage;

	public NewGrecotoDiagramWizard() {
		super();

		setNeedsProgressMonitor(true);
		setWindowTitle("New Ecore Diagram");
	}

	@Override
	public void addPages() {
		// ecore file
		ecoreFilePage = new WizardNewFileCreationPage(EcoditoConstants.EXTENSION_ECORE, selection);
		ecoreFilePage.setTitle("Model File");
		ecoreFilePage.setDescription("Select the file that should contain the Ecore model. Or an existing one.");
		ecoreFilePage.setImageDescriptor(GrecotoImages.getDescriptor(GrecotoImages.WIZBAN_ECORE));
		ecoreFilePage.setFileName(EcoditoConstants.DEFAULT_FILENAME);
		ecoreFilePage.setFileExtension(EcoditoConstants.EXTENSION_ECORE);
		ecoreFilePage.setAllowExistingResources(true);
		addPage(ecoreFilePage);

		// genmodel file
		genmodelFilePage = new WizardNewFileCreationPage(EcoditoConstants.EXTENSION_GENMODEL, selection);
		genmodelFilePage.setTitle("Generator File");
		genmodelFilePage.setDescription("Select the file that should contain the Generator model. Or an existing one.");
		genmodelFilePage.setImageDescriptor(GrecotoImages.getDescriptor(GrecotoImages.WIZBAN_GENMODEL));
		genmodelFilePage.setFileName(EcoditoConstants.DEFAULT_FILENAME);
		genmodelFilePage.setFileExtension(EcoditoConstants.EXTENSION_GENMODEL);
		genmodelFilePage.setAllowExistingResources(true);
		addPage(genmodelFilePage);

		// diagram file
		diagramFilePage = new WizardNewFileCreationPage(EcoditoConstants.EXTENSION_DIAGRAM, selection);
		diagramFilePage.setTitle("Diagram File");
		diagramFilePage.setDescription("Select the file that should contain the diagrams.");
		diagramFilePage.setImageDescriptor(GrecotoImages.getDescriptor(GrecotoImages.WIZBAN_DIAGRAM));
		diagramFilePage.setFileName(EcoditoConstants.DEFAULT_FILENAME);
		diagramFilePage.setFileExtension(EcoditoConstants.EXTENSION_DIAGRAM);
		diagramFilePage.setAllowExistingResources(false);
		addPage(diagramFilePage);
	}

	@Override
	public void init(IWorkbench workbench, IStructuredSelection selection) {
		this.selection = selection;
	}

	@Override
	public boolean performFinish() {
		final ResourceSet resourceSet = new ResourceSetImpl();

		final IPath ecorePath = ecoreFilePage.getContainerFullPath().append(ecoreFilePage.getFileName());
		final IPath genmodelPath = genmodelFilePage.getContainerFullPath().append(genmodelFilePage.getFileName());
		final IPath diagramPath = diagramFilePage.getContainerFullPath().append(diagramFilePage.getFileName());

		IRunnableWithProgress runnable = new IRunnableWithProgress() {
			@Override
			public void run(IProgressMonitor monitor) throws InvocationTargetException, InterruptedException {
				// ecore model
				URI ecoreUri = URI.createPlatformResourceURI(ecorePath.toPortableString(), true);
				Resource ecoreResource;
				EPackage ecoreRoot = null;
				if (ecoreUri.isFile()) {
					ecoreResource = resourceSet.getResource(ecoreUri, true);

					for (EObject content : ecoreResource.getContents()) {
						if (content instanceof EPackage) {
							ecoreRoot = (EPackage) content;
						}
					}

					// FIXME: handle existing
					if (ecoreRoot == null) {
						throw new InvocationTargetException(null, "Could not find EPackage in the resource.");
					}
				} else {
					ecoreResource = resourceSet.createResource(ecoreUri);

					// create root package
					ecoreRoot = EcoreFactory.eINSTANCE.createEPackage();

					// add to resource
					ecoreResource.getContents().add(ecoreRoot);

					try {
						ecoreResource.save(Collections.emptyMap());
					} catch (IOException e) {
						throw new InvocationTargetException(e);
					}
				}

				// genmodel
				URI genmodelUri = URI.createPlatformResourceURI(genmodelPath.toPortableString(), true);
				Resource genmodelResource;
				GenModel genmodelRoot = null;
				if (genmodelUri.isFile()) {
					genmodelResource = resourceSet.getResource(genmodelUri, true);

					for (EObject content : genmodelResource.getContents()) {
						if (content instanceof GenModel) {
							genmodelRoot = (GenModel) content;
							break;
						}
					}

					// FIXME: handle existing
					if (genmodelRoot == null) {
						throw new InvocationTargetException(null, "Could not find EPackage in the resource.");
					}
				} else {
					genmodelResource = resourceSet.createResource(genmodelUri);
					genmodelRoot = GenModelFactory.eINSTANCE.createGenModel();

					// FIXME: convert/reload gen package

					genmodelRoot.getForeignModel().add(ecoreResource.getURI().toPlatformString(true));
					GenPackage genPackage = GenModelFactory.eINSTANCE.createGenPackage();
					genPackage.setEcorePackage(ecoreRoot);
					genmodelRoot.getGenPackages().add(genPackage);

					try {
						genmodelResource.save(Collections.emptyMap());
					} catch (IOException e) {
						throw new InvocationTargetException(e);
					}
				}

				// diagram
				URI diagramUri = URI.createPlatformResourceURI(diagramPath.toPortableString(), true);
				Resource diagramResource;

				if (diagramUri.isFile()) {
					diagramResource = resourceSet.getResource(diagramUri, true);

					diagramResource.getContents().clear();
				} else {
					diagramResource = resourceSet.createResource(diagramUri);
				}

				// create diagram
				String diagramTypeId = EcoditoConstants.DIAGRAM_TYPE_ID;
				String diagramName = ((ecoreRoot.getName() == null || ecoreRoot.getName().isEmpty()) ? "" : ecoreRoot
						.getName());
				Diagram diagramRoot = Graphiti.getPeService().createDiagram(diagramTypeId, diagramName, true);

				PictogramLink link = PictogramsFactory.eINSTANCE.createPictogramLink();
				link.setPictogramElement(diagramRoot);
				link.getBusinessObjects().add(ecoreRoot);

				diagramResource.getContents().add(diagramRoot);

				try {
					diagramResource.save(Collections.emptyMap());
				} catch (IOException e) {
					throw new InvocationTargetException(e);
				}
			}
		};

		try {
			getContainer().run(true, false, runnable);
		} catch (InvocationTargetException e) {
			e.printStackTrace();
			return false;
		} catch (InterruptedException e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}
}
