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
import org.eclipse.graphiti.features.impl.Reason
import org.eclipse.graphiti.mm.algorithms.Image
import org.eclipse.graphiti.mm.algorithms.Text
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EEnumLiteralCreateFeature extends CoreCreateFeature {
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Literal"
		description = "Create Literal"
		imageId = identifier
		largeImageId = identifier

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
	extension AddService = AddService::INSTANCE
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		context.container.addContainerShape [
			link = context.newObject
			newRectangle[
				position = context.position
				size = context.size(150, 20)
				style = diagram.shapeStyle
				newImage[ // attribute symbol
					id = context.EEnumLiteral.symbol
					position = #[2, 2]
					size = #[16, 16]
				]
				newText[ // attribute text
					position = #[20, 0]
					size = #[150, 20]
					style = diagram.textStyle
					value = context.EEnumLiteral.name
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EEnumLiteral != null
	}
}

class EEnumLiteralUpdateFeature extends AbstractUpdateFeature {
	extension EEnumLiteralExtensions = EEnumLiteralExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EEnumLiteral != null
	}

	override updateNeeded(IUpdateContext context) {
		if (context.EEnumLiteral.text != context.text.value) {
			return Reason::createTrueReason
		}

		if (context.EEnumLiteral.symbol != context.symbol.id) {
			return Reason::createTrueReason
		}

		return Reason::createFalseReason
	}

	def String getText(EEnumLiteral element) {
		return '''«element.name» = «element.value»'''
	}

	def Text getText(IUpdateContext element) {
		element.pictogramElement.graphicsAlgorithm.graphicsAlgorithmChildren.get(1) as Text
	}

	def Image getSymbol(IUpdateContext element) {
		element.pictogramElement.graphicsAlgorithm.graphicsAlgorithmChildren.get(0) as Image
	}

	override update(IUpdateContext context) {
		if (context.EEnumLiteral.text != context.text.value) {
			context.text.value = context.EEnumLiteral.text
		}

		if (context.EEnumLiteral.symbol != context.symbol.id) {
			context.symbol.id = context.EEnumLiteral.symbol
		}

		return true
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
