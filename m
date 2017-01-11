Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34184 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752468AbdAKIm3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 03:42:29 -0500
Date: Wed, 11 Jan 2017 09:42:28 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v8 6/6] xfs: sanity check inode di_mode
Message-ID: <20170111084228.GD6744@lst.de>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com> <1484123050-11064-7-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484123050-11064-7-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jan 11, 2017 at 10:24:10AM +0200, Amir Goldstein wrote:
> Check for invalid file type in xfs_dinode_verify()
> and fail to load the inode structure from disk.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
