package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.core.graphiti.pattern.CorePattern
import com.aljoschability.eclipse.ecodito.diagram.util.EEnumLiteralExtensions
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.pattern.config.IPatternConfiguration
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.util.IColorConstant

class EEnumLiteralCreateFeature extends CoreCreateFeature {
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Literal"
		description = "Create Literal"
		imageId = EcorePackage.Literals::EENUM_LITERAL.name
		largeImageId = EcorePackage.Literals::EENUM_LITERAL.name

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.EEnum != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEEnumLiteral

		context.EEnum.ELiterals += element

		return element
	}
}

class EEnumLiteralPattern extends CorePattern {
	new(IPatternConfiguration patternConfiguration) {
		super();
	}

	override add(IAddContext context) {
		val cpe = context.getTargetContainer();

		val pe = Graphiti.getPeService().createContainerShape(cpe, true);
		val bo = context.getNewObject() as EEnumLiteral;
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
		val eEnum = getBO(context.getTargetContainer()) as EEnum;

		val element = EcoreFactory.eINSTANCE.createEEnumLiteral();
		eEnum.getELiterals().add(element);

		return element;
	}

	override canCreate(ICreateContext context) {
		return getBO(context.getTargetContainer()) instanceof EEnum;
	}

	override protected isBO(Object bo) {
		return bo instanceof EEnumLiteral;
	}

	override protected getEClass() {
		return EcorePackage.Literals.EENUM_LITERAL;
	}
}
