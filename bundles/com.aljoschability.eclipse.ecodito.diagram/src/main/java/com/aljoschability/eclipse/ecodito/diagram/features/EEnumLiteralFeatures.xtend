package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EEnumLiteralExtensions
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.features.impl.AbstractAddFeature
import org.eclipse.graphiti.features.impl.AbstractLayoutFeature
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.services.Graphiti
import org.eclipse.graphiti.util.IColorConstant

class EEnumLiteralCreateFeature extends CoreCreateFeature {
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Literal"
		description = "Create Literal"
		imageId = icon
		largeImageId = icon

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

class EEnumLiteralAddFeature extends AbstractAddFeature {
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		val cpe = context.getTargetContainer()

		val pe = Graphiti.getPeService().createContainerShape(cpe, true)
		val bo = context.getNewObject() as EEnumLiteral
		link(pe, bo)

		// main rectangle
		val ga = Graphiti.getGaService().createPlainRoundedRectangle(pe, 0, 0)
		ga.setCornerHeight(16)
		ga.setCornerWidth(16)
		ga.setLineWidth(1)
		ga.setBackground(manageColor(IColorConstant.WHITE))
		ga.setForeground(manageColor(IColorConstant.BLACK))

		ga.setX(context.getX())
		ga.setY(context.getY())
		ga.setWidth(context.getWidth())
		ga.setHeight(context.getHeight())

		// name text
		val nameText = Graphiti.getGaService().createPlainText(ga)
		nameText.setValue(bo.getName())
		nameText.setForeground(manageColor(IColorConstant.BLACK))
		nameText.setFilled(false)

		nameText.setX(0)
		nameText.setY(0)
		nameText.setWidth(ga.getWidth())
		nameText.setHeight(20)

		return pe
	}

	override canAdd(IAddContext context) {
		context.EEnumLiteral != null
	}
}

class EEnumLiteralUpdateFeature extends AbstractUpdateFeature {
	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		false
	}

	override update(IUpdateContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override updateNeeded(IUpdateContext context) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
}

class EEnumLiteralLayoutFeature extends AbstractLayoutFeature {
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EEnumLiteral != null
	}

	override layout(ILayoutContext context) {
		false
	}
}
