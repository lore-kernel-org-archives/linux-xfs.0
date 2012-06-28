Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5SJsa6X059526 for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 14:54:36 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bysogOJAgYplMrxg for
	<xfs@oss.sgi.com>; Thu, 28 Jun 2012 12:54:35 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5SJsY7w028883
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 15:54:35 -0400
Received: from andromeda.usersys.redhat.com (vpn1-4-135.gru2.redhat.com
	[10.97.4.135])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q5SJsV5r011114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2012 15:54:34 -0400
Date: Thu, 28 Jun 2012 16:54:31 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: cleanup the mount options
Message-ID: <20120628195431.GA15544@andromeda.usersys.redhat.com>
References: <1340816243-6177-1-git-send-email-gaowanlong@cn.fujitsu.com>
	<20120627174448.GA3278@infradead.org>
	<4FEBAB3B.6020707@cn.fujitsu.com> <20120628160156.GC29979@sgi.com>
	<4FEC8768.8000109@zabbo.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FEC8768.8000109@zabbo.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Jun 28, 2012 at 09:33:44AM -0700, Zach Brown wrote:
> 
> >It's not a strong objection from me, but I do have a preference for keeping the
> >XFS_MOUNT_ prefix to retain context for cscope and grep.  Maybe others feel
> >differently.
> 
> For what it's worth, I agree.  It's really annoying to have cscope
> lookups fail and have to go poking around for things manually.
> 
+1

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
