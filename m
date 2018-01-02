Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:49736 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750917AbeABXPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 18:15:08 -0500
Date: Wed, 3 Jan 2018 10:15:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/20] xfs: refactor long-format btree header
 verification routines
Message-ID: <20180102231501.GX5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399123598.23543.17447669553893249804.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399123598.23543.17447669553893249804.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:07:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create two helper functions to verify the headers of a long format
> btree block.  We'll use this later for the realtime rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
