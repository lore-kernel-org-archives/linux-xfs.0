Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49590 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752338AbeC0XEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:04:50 -0400
Date: Wed, 28 Mar 2018 10:04:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/20] xfs: add repair helpers for the reference count
 btree
Message-ID: <20180327230448.GV18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210857946.13184.11202190514229464537.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210857946.13184.11202190514229464537.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of functions to the refcount btree and generic btree code
> that will be used to repair the refcountbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
