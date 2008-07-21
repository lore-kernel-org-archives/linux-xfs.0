Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:53:39 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBrbW5023979
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:53:38 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDC37190FB5A
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:54:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id usGh8UXnW8MvDrFh for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:54:47 -0700 (PDT)
Date: Mon, 21 Jul 2008 07:54:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] XFS: Use KM_NOFS for incore inode extent tree
	allocation V2
Message-ID: <20080721115447.GA14346@infradead.org>
References: <1216638192-6292-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216638192-6292-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks good.
