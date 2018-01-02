Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:8146 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751024AbeABXRP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 18:17:15 -0500
Date: Wed, 3 Jan 2018 10:17:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/20] xfs: refactor short form btree pointer verification
Message-ID: <20180102231712.GY5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399124206.23543.2218961061872626742.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399124206.23543.2218961061872626742.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:07:22PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have xfs_verify_agbno, use it to verify short form btree
> pointers instead of open-coding them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

All good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
