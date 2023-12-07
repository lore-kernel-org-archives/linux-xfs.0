Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2744410CE
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:06:31 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1662B227A87; Thu,  7 Dec 2023 06:06:28 +0100 (CET)
Date: Thu, 7 Dec 2023 06:06:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: chandanbabu@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: recompute growfsrtfree transaction
 reservation while growing rt volume
Message-ID: <20231207050627.GA16149@lst.de>
References: <170191563642.1133893.14966073508617867491.stgit@frogsfrogsfrogs> <170191563659.1133893.4605821704716263615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191563659.1133893.4605821704716263615.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
