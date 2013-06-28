Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C484C7F50
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 11:31:01 -0500 (CDT)
Date: Fri, 28 Jun 2013 11:30:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v10 05/11] xfs: Do some whitespace cleanup in the data
	structure xfs_quotainfo
Message-ID: <20130628163058.GW20932@sgi.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
	<1372371914-11370-6-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372371914-11370-6-git-send-email-sekharan@us.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

Hey Chandra,

On Thu, Jun 27, 2013 at 05:25:08PM -0500, Chandra Seetharaman wrote:
> In preparation for combined pquota/gquota support, do some
> whitespace cleanups.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Wow.  Putting this in a patch by itself really puts it into stark
relief.

If we pull this in we're representing that some tabs and the alignment
of the fields is more valuable than the comments?  I'm fairly certain I
don't agree that's the case...

I'm sorry for your trouble, but I think I should pass on this one.  Do
you agree?

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
