package com.aljoschability.eclipse.ecodito.diagram;

import com.aljoschability.eclipse.core.graphiti.editors.CoreToolBehaviorProvider
import com.aljoschability.eclipse.ecodito.diagram.features.EAttributeCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EClassCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EDataTypeCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EEnumLiteralCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EOperationCreateFeature
import com.aljoschability.eclipse.ecodito.diagram.features.EReferenceCreateFeature
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.graphiti.dt.IDiagramTypeProvider
import org.eclipse.graphiti.palette.IPaletteCompartmentEntry
import org.eclipse.graphiti.palette.impl.PaletteCompartmentEntry
import org.eclipse.graphiti.palette.impl.PaletteSeparatorEntry

class EcoditoToolBehaviorProvider extends CoreToolBehaviorProvider {
	new(IDiagramTypeProvider dtp) {
		super(dtp)
	}

	override getPalette() {
		val entries = newArrayList

		entries += createEClassEntries
		entries += createEEnumEntries
		entries += createEDataTypeEntries

		return entries
	}

	def private IPaletteCompartmentEntry createEClassEntries() {
		val entry = new PaletteCompartmentEntry("Class", EcorePackage.Literals::ECLASS.name)

		entry.toolEntries += new EClassCreateFeature(featureProvider).creationTool

		entry.toolEntries += new PaletteSeparatorEntry
		entry.toolEntries += new EAttributeCreateFeature(featureProvider).creationTool

		entry.toolEntries += new EReferenceCreateFeature(featureProvider).creationTool
		entry.toolEntries += new PaletteSeparatorEntry

		entry.toolEntries += new EOperationCreateFeature(featureProvider).creationTool
		return entry
	}

	def private IPaletteCompartmentEntry createEEnumEntries() {
		val entry = new PaletteCompartmentEntry("Enumeration", EcorePackage.Literals::ECLASS.name)

		entry.toolEntries += new EEnumCreateFeature(featureProvider).creationTool

		entry.toolEntries += new PaletteSeparatorEntry

		entry.toolEntries += new EEnumLiteralCreateFeature(featureProvider).creationTool
		return entry
	}

	def private IPaletteCompartmentEntry createEDataTypeEntries() {
		val entry = new PaletteCompartmentEntry("Data Type", EcorePackage.Literals::ECLASS.name)

		entry.toolEntries += new EDataTypeCreateFeature(featureProvider).creationTool

		return entry
	}
}
