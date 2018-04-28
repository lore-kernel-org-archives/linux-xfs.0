Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752083AbeD1Gro (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Apr 2018 02:47:44 -0400
Date: Fri, 27 Apr 2018 23:47:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/13] xfs: rename on-disk dquot counter zap functions
Message-ID: <20180428064739.GE1661@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
 <152440963795.29601.14844972913332721242.stgit@magnolia>
 <20180423173548.GL834@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180423173548.GL834@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 23, 2018 at 07:35:48PM +0200, Christoph Hellwig wrote:
> I agree with getting rid of the old names, but what about
> 
> xfs_qm_reset_dqcounts_buf and xfs_qm_reset_dqcounts_all to fit with
> the naming for the existing xfs_qm_reset_dqcounts low-level function?

Sounds good to me.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
