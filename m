Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2F86DD08
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9B52D68CFE; Fri, 12 Jan 2024 17:48:17 +0100 (CET)
Date: Fri, 12 Jan 2024 17:48:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] libxfs: remove the unused fs_topology_t typedef
Message-ID: <20240112164817.GC16766@lst.de>
References: <20240112044743.2254211-1-hch@lst.de> <20240112044743.2254211-2-hch@lst.de> <20240112164450.GU722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112164450.GU722975@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 12, 2024 at 08:44:50AM -0800, Darrick J. Wong wrote:
> Dumb nit: the ampersand in the comment can go away too ^

It'll go away in the next patch.

