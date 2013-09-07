package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EOperationExtensions
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
import org.eclipse.emf.ecore.EOperation
import org.eclipse.graphiti.mm.algorithms.Text
import org.eclipse.graphiti.mm.algorithms.Image
import com.aljoschability.eclipse.core.graphiti.services.AddService

class EOperationCreateFeature extends CoreCreateFeature {
	extension EOperationExtensions = EOperationExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Operation"
		description = "Create Operation"
		imageId = identifier
		largeImageId = identifier

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.EClass != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEOperation

		context.EClass.EOperations += element

		return element
	}
}

class EOperationAddFeature extends AbstractAddFeature {
	extension AddService = AddService::INSTANCE
	extension EOperationExtensions = EOperationExtensions::INSTANCE

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
					id = context.EOperation.symbol
					position = #[2, 2]
					size = #[16, 16]
				]
				newText[ // attribute text
					position = #[20, 0]
					size = #[150, 20]
					style = diagram.textStyle
					value = context.EOperation.name
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.EOperation != null
	}
}

class EOperationUpdateFeature extends AbstractUpdateFeature {
	extension EOperationExtensions = EOperationExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EOperation != null
	}

	override updateNeeded(IUpdateContext context) {
		if (context.EOperation.text != context.text.value) {
			return Reason::createTrueReason
		}

		if (context.EOperation.symbol != context.symbol.id) {
			return Reason::createTrueReason
		}

		return Reason::createFalseReason
	}

	def String getText(EOperation element) {
		val parameters = new StringBuilder
		var i = element.EParameters.length
		for (p : element.EParameters) {
			parameters.append(p.name)
			if (i > 1) {
				parameters.append(", ")
			}
			i--
		}

		return '''«element.name»(«parameters»)'''
	}

	def Text getText(IUpdateContext element) {
		element.pictogramElement.graphicsAlgorithm.graphicsAlgorithmChildren.get(1) as Text
	}

	def Image getSymbol(IUpdateContext element) {
		element.pictogramElement.graphicsAlgorithm.graphicsAlgorithmChildren.get(0) as Image
	}

	override update(IUpdateContext context) {
		if (context.EOperation.text != context.text.value) {
			context.text.value = context.EOperation.text
		}

		if (context.EOperation.symbol != context.symbol.id) {
			context.symbol.id = context.EOperation.symbol
		}

		return true
	}

}

class EOperationLayoutFeature extends AbstractLayoutFeature {
	extension EOperationExtensions = EOperationExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EOperation != null
	}

	override layout(ILayoutContext context) {
		false
	}
}
