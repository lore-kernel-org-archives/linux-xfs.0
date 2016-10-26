Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:60893 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750832AbcJZDXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 23:23:55 -0400
Date: Wed, 26 Oct 2016 14:23:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/39] xfs_db: print one array element per line
Message-ID: <20161026032308.GH23194@dastard>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743669846.11035.8419161903309169766.stgit@birch.djwong.org>
 <20161026005138.GE23194@dastard>
 <20161026011343.GD23568@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026011343.GD23568@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 25, 2016 at 06:13:43PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 26, 2016 at 11:51:38AM +1100, Dave Chinner wrote:
> > On Tue, Oct 25, 2016 at 04:04:58PM -0700, Darrick J. Wong wrote:
> > > Print one array element per line so that the debugger output isn't
> > > a gigantic pile of screen snow.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > What commands does this affect?
> 
> The 'print' command.

Ok, let me be more specific - what is an example of the change of
behaviour? printing bmbt records in a block, or something else?
Can you post a before/after example?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
