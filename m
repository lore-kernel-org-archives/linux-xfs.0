Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40783 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932800AbdAIVei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 16:34:38 -0500
Date: Mon, 9 Jan 2017 13:34:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: constify struct iomap_ops
Message-ID: <20170109213433.GB3732@birch.djwong.org>
References: <1483901500-1728-1-git-send-email-hch@lst.de>
 <20170108203627.GA14038@birch.djwong.org>
 <20170109125750.GA23248@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170109125750.GA23248@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jan 09, 2017 at 01:57:50PM +0100, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 12:36:27PM -0800, Darrick J. Wong wrote:
> > Looks reasonable enough to me, so
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We've been maintaining the iomap code through the XFS tree in the past,
> so you should probably pick it up.

Sure, I'll tag it for 4.11 xfs.

--D
