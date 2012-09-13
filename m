Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8DELQcp168655 for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 09:21:27 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hGoVBkbR5IVVeM5w for
	<xfs@oss.sgi.com>; Thu, 13 Sep 2012 07:22:33 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8DEMWFW015567
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 10:22:33 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com
	[10.3.113.109])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8DEMTdQ024866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2012 10:22:32 -0400
Date: Thu, 13 Sep 2012 11:22:29 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: userspace trees
Message-ID: <20120913142229.GA4382@andromeda.usersys.redhat.com>
References: <20120913075026.GA27256@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120913075026.GA27256@infradead.org>
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

On Thu, Sep 13, 2012 at 03:50:26AM -0400, Christoph Hellwig wrote:
> It seems with the kernel.org account purge last year and me being way to
> busy it seems like the -dev trees of the XFS userspace get very little
> attention.  What do people think about retiring them and using the oss
> trees exclusively again for now?  Right now the trees are getting a bit
> out of sync which isn't a good thing.
> 
Maintaining oss only looks easier to me and less error prone (in regards on keep
trees synchronized) than still keep the kernel.org xfs tree.

To be honest I've never used the kernel.org xfs trees, so, at least for me this
makes sense.

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
