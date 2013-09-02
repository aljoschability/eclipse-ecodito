package com.aljoschability.eclipse.ecodito.diagram.features;

import com.aljoschability.eclipse.core.graphiti.features.CoreCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.util.EClassExtensions
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.features.IFeatureProvider
import org.eclipse.graphiti.features.context.IAddContext
import org.eclipse.graphiti.features.context.ICreateContext
import org.eclipse.graphiti.features.context.ILayoutContext
import org.eclipse.graphiti.features.context.IUpdateContext
import org.eclipse.graphiti.features.impl.AbstractAddFeature
import org.eclipse.graphiti.features.impl.AbstractLayoutFeature
import org.eclipse.graphiti.features.impl.AbstractUpdateFeature
import org.eclipse.graphiti.features.impl.Reason
import org.eclipse.graphiti.util.IColorConstant

class EClassAddFeature extends AbstractAddFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override add(IAddContext context) {
		val bo = context.EClass
		val nameText = bo.name

		addContainerShape[
			container = context.container
			active = true
			link = context.newObject
			val frame = addRoundedRectangle[
				background = IColorConstant::WHITE
				foreground = IColorConstant::BLACK
				radius = 16
				position = context.position
				size = context.size(200, 100)
				val titleSymbol = addImage[
					//name = "title.symbol"
					id = EClass.simpleName
					position = #[7, 7]
					size = #[16, 16]
				]
				val titleText = addText[
					//name = "title.text"
					position = #[27, 5]
					width = parentGraphicsAlgorithm.width - 54
					foreground = IColorConstant::BLACK
					height = 20
					//font = nameFont
					value = nameText
				]
				val titleSeparator = addPolyline[
					//name = "title.separator"
					addPoint(0, 29)
					addPoint(parentGraphicsAlgorithm.width, 29)
				]
			]
		]
	}

	override canAdd(IAddContext context) {
		context.newObject instanceof EClass && context.EPackage != null
	}
}

class EClassCreateFeature extends CoreCreateFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)

		name = "Class"
		description = "Create Class"
		imageId = icon
		largeImageId = icon

		editable = true
	}

	override canCreate(ICreateContext context) {
		return context.EPackage != null
	}

	override createElement(ICreateContext context) {
		val element = EcoreFactory::eINSTANCE.createEClass

		context.EPackage.EClassifiers += element

		return element
	}
}

class EClassLayoutFeature extends AbstractLayoutFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canLayout(ILayoutContext context) {
		context.EClass != null
	}

	override layout(ILayoutContext context) {
		false
	}
}

class EClassUpdateFeature extends AbstractUpdateFeature {
	extension EClassExtensions = EClassExtensions::INSTANCE

	new(IFeatureProvider fp) {
		super(fp)
	}

	override canUpdate(IUpdateContext context) {
		context.EClass != null
	}

	override updateNeeded(IUpdateContext context) {
		Reason::createFalseReason
	}

	override update(IUpdateContext context) {
		false
	}
}
