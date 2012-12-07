package com.aljoschability.eclipse.ecodito.ui.patterns;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EcoreFactory;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.graphiti.features.context.IAddContext;
import org.eclipse.graphiti.features.context.ICreateContext;
import org.eclipse.graphiti.mm.algorithms.RoundedRectangle;
import org.eclipse.graphiti.mm.algorithms.Text;
import org.eclipse.graphiti.mm.pictograms.ContainerShape;
import org.eclipse.graphiti.mm.pictograms.PictogramElement;
import org.eclipse.graphiti.pattern.config.IPatternConfiguration;
import org.eclipse.graphiti.services.Graphiti;
import org.eclipse.graphiti.util.IColorConstant;

import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern;

public class EAttributePattern extends CorePattern {
	public EAttributePattern(IPatternConfiguration patternConfiguration) {
		super();
	}

	@Override
	public PictogramElement add(IAddContext context) {
		ContainerShape cpe = context.getTargetContainer();

		ContainerShape pe = Graphiti.getPeService().createContainerShape(cpe, true);
		EAttribute bo = (EAttribute) context.getNewObject();
		link(pe, bo);

		// main rectangle
		RoundedRectangle ga = Graphiti.getGaService().createPlainRoundedRectangle(pe, 0, 0);
		ga.setCornerHeight(16);
		ga.setCornerWidth(16);
		ga.setLineWidth(1);
		ga.setBackground(manageColor(IColorConstant.WHITE));
		ga.setForeground(manageColor(IColorConstant.BLACK));

		ga.setX(context.getX());
		ga.setY(context.getY());
		ga.setWidth(context.getWidth());
		ga.setHeight(context.getHeight());

		// name text
		Text nameText = Graphiti.getGaService().createPlainText(ga);
		nameText.setValue(bo.getName());
		nameText.setForeground(manageColor(IColorConstant.BLACK));
		nameText.setFilled(false);

		nameText.setX(0);
		nameText.setY(0);
		nameText.setWidth(ga.getWidth());
		nameText.setHeight(20);

		return pe;
	}

	@Override
	protected EObject createElement(ICreateContext context) {
		EClass eClass = (EClass) getBO(context.getTargetContainer());

		EAttribute element = EcoreFactory.eINSTANCE.createEAttribute();
		eClass.getEStructuralFeatures().add(element);

		return element;
	}

	@Override
	public boolean canCreate(ICreateContext context) {
		return getBO(context.getTargetContainer()) instanceof EClass;
	}

	@Override
	protected boolean isBO(Object bo) {
		return bo instanceof EAttribute;
	}

	@Override
	protected EClass getEClass() {
		return EcorePackage.Literals.EATTRIBUTE;
	}
}
