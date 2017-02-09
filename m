Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50754 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751543AbdBIHVc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 02:21:32 -0500
Date: Thu, 9 Feb 2017 08:21:07 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] xfs: allocate direct I/O COW blocks in iomap_begin
Message-ID: <20170209072107.GA6134@lst.de>
References: <20170206074738.13978-1-hch@lst.de> <20170206074738.13978-5-hch@lst.de> <20170207014149.GE12378@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207014149.GE12378@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Mon, Feb 06, 2017 at 05:41:49PM -0800, Darrick J. Wong wrote:
> I'm going to run this series (and all the other stuff I've collected for
> 4.11) overnight and if nothing screams then you can consider this series:

Can you push your tree out?  I'd like to verify what made it before
heading off for a long weekend tonight. I'm especially curious if
the discard work made it.
