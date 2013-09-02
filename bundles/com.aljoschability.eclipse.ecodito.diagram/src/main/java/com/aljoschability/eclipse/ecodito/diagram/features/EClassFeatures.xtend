package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.pattern.config.IPatternConfiguration
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.util.IColorConstant
import org.eclipse.graphiti.features.IFeatureProvider
import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature

class EClassCreateFeature extends CoreCreateFeature {
	new(IFeatureProvider fp) {
		super(fp)

		name = "EClass"
		description = "Create EClass"
		imageId = EClass.simpleName
		largeImageId = EClass.simpleName

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.targetContainer.businessObjectForPictogramElement instanceof EPackage
	}

	override createElement(ICreateContext context) {
		val p = context.targetContainer.businessObjectForPictogramElement as EPackage

		val element = EcoreFactory::eINSTANCE.createEClass
		p.EClassifiers += element

		return element
	}
}

class EClassPattern extends CorePattern {
	new(IPatternConfiguration patternConfiguration) {
		super();
	}

	override add(IAddContext context) {
		val cpe = context.getTargetContainer();

		val pe = Graphiti.getPeService().createContainerShape(cpe, true);
		val bo = context.getNewObject() as EClass;
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

		// line
		var lineCoords = #[0, 20, ga.getWidth(), 20]
		val line = Graphiti.getGaService().createPlainPolyline(ga, lineCoords);
		line.setForeground(manageColor(IColorConstant.BLACK));
		line.setWidth(1);

		// line
		lineCoords = #[0, 20, ga.getWidth(), 20]
		val line2 = Graphiti.getGaService().createPlainPolyline(ga, lineCoords);
		line2.setForeground(manageColor(IColorConstant.BLACK));
		line2.setWidth(1);

		return pe;
	}

	override updateNeeded(IUpdateContext context) {
		val pe = context.getPictogramElement();
		val bo = getBO(pe);

		// check name text
		return super.updateNeeded(context);
	}

	override protected createElement(ICreateContext context) {
		val ePackage = getBO(context.getTargetContainer()) as EPackage;

		val element = EcoreFactory.eINSTANCE.createEClass();
		ePackage.getEClassifiers().add(element);

		return element;
	}

	override canCreate(ICreateContext context) {
		return getBO(context.getTargetContainer()) instanceof EPackage;
	}

	override protected isBO(Object bo) {
		return bo instanceof EClass;
	}

	override protected getEClass() {
		return EcorePackage.Literals.ECLASS;
	}
}
