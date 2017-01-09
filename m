Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45480 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S939628AbdAIM5x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 07:57:53 -0500
Date: Mon, 9 Jan 2017 13:57:50 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: constify struct iomap_ops
Message-ID: <20170109125750.GA23248@lst.de>
References: <1483901500-1728-1-git-send-email-hch@lst.de> <20170108203627.GA14038@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170108203627.GA14038@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun, Jan 08, 2017 at 12:36:27PM -0800, Darrick J. Wong wrote:
> Looks reasonable enough to me, so
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

We've been maintaining the iomap code through the XFS tree in the past,
so you should probably pick it up.
