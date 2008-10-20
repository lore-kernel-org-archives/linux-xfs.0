Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 14:41:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KLfPVs005177
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 14:41:26 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D61A41448FD2
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 14:43:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id blMXDbvu7MNvFQy2 for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 14:43:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1Ks2Ws-0006pD-LS
	for xfs@oss.sgi.com; Mon, 20 Oct 2008 21:43:10 +0000
Date: Mon, 20 Oct 2008 17:43:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: git tree updates....
Message-ID: <20081020214310.GA26172@infradead.org>
References: <20081017054742.GH31761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017054742.GH31761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

While we at it, the b0rked m_vfsmount addition for DMAPI keeps on
leaking into the git tree for -next..
