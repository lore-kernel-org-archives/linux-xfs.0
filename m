Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33690 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdLGAR5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 19:17:57 -0500
Date: Thu, 7 Dec 2017 01:17:56 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
        creations
Message-ID: <20171207001756.GA19124@lst.de>
References: <20170821082404.3387-1-hch@lst.de> <20171207001556.GQ19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171207001556.GQ19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Dec 06, 2017 at 04:15:56PM -0800, Darrick J. Wong wrote:
> Ok, so the xfstests fixes were pretty straightforward, so can I get a
> signed-off-by for this patch?

I can't believe I missed that :)

Signed-off-by: Christoph Hellwig <hch@lst.de>
