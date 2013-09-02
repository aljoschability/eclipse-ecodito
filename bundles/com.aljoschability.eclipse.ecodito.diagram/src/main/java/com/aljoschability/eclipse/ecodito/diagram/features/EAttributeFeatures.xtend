package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.pattern.config.IPatternConfiguration
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.util.IColorConstant

class EAttributePattern extends CorePattern {
	new(IPatternConfiguration patternConfiguration) {
		super();
	}

	override add(IAddContext context) {
		val cpe = context.getTargetContainer();

		val pe = Graphiti.getPeService().createContainerShape(cpe, true);
		val bo = context.getNewObject() as EAttribute;
		link(pe, bo);

		// main rectangle
		val ga = Graphiti.getGaService().createPlainRoundedRectangle(pe, 0, 0);
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
		val nameText = Graphiti.getGaService().createPlainText(ga);
		nameText.setValue(bo.getName());
		nameText.setForeground(manageColor(IColorConstant.BLACK));
		nameText.setFilled(false);

		nameText.setX(0);
		nameText.setY(0);
		nameText.setWidth(ga.getWidth());
		nameText.setHeight(20);

		return pe;
	}

	override protected createElement(ICreateContext context) {
		val eClass = getBO(context.getTargetContainer()) as EClass;

		val element = EcoreFactory.eINSTANCE.createEAttribute();
		eClass.getEStructuralFeatures().add(element);

		return element;
	}

	override canCreate(ICreateContext context) {
		return getBO(context.getTargetContainer()) instanceof EClass;
	}

	override protected isBO(Object bo) {
		return bo instanceof EAttribute;
	}

	override protected getEClass() {
		return EcorePackage.Literals.EATTRIBUTE;
	}
}
