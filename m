Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C846109
	for <linux-xfs@vger.kernel.org>; Thu, 28 Dec 2023 06:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 242A468D07; Thu, 28 Dec 2023 07:22:36 +0100 (CET)
Date: Thu, 28 Dec 2023 07:22:35 +0100
From: Christoph Hellwig <hch@lst.de>
To: chandan.babu@oracle.com
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use the op name in
 trace_xlog_intent_recovery_failed
Message-ID: <20231228062235.GA12678@lst.de>
References: <20231228061821.337263-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231228061821.337263-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Please direcard this mail - this was supposed to be sent as patch 2
of the series I just sent.

