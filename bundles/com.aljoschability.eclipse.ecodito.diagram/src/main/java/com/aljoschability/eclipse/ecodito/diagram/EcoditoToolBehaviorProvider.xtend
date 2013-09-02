package com.aljoschability.eclipse.ecodito.diagram;

import com.aljoschability.eclipse.core.graphiti.editors.CoreToolBehaviorProvider
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.palette.IPaletteCompartmentEntry
import org.eclipse.graphiti.palette.impl.PaletteCompartmentEntry
import com.aljoschability.eclipse.ecodito.diagram.features.EClassCreateFeature

class EcoditoToolBehaviorProvider extends CoreToolBehaviorProvider {
	new(IDiagramTypeProvider dtp) {
		super(dtp)
	}

	override getPalette() {
		val entries = newArrayList

		entries += createClassifierEntries

		return entries
	}

	def private IPaletteCompartmentEntry createClassifierEntries() {
		val entry = new PaletteCompartmentEntry("Classifier", EcorePackage.Literals::ECLASS.name)

		entry.toolEntries += new EClassCreateFeature(featureProvider).creationTool
		//entry.toolEntries += new EEnumCreateFeature(featureProvider).creationTool

		return entry
	}
}
