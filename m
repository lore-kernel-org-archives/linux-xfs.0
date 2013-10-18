Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89BAA7F54
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:27:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68D42304043
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:27:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id j7GQqOG4RL8GFBVi for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:27:28 -0700 (PDT)
Message-ID: <52616F7E.7040003@redhat.com>
Date: Fri, 18 Oct 2013 12:27:26 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] xfstests: Test xfs_fsr / swapext management of
	di_forkoff w/ selinux
References: <5260B62D.2010507@redhat.com> <52616072.6040808@sandeen.net>
	<20131018172635.GE11404@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20131018172635.GE11404@dhcp-13-216.nay.redhat.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On 10/18/13 12:26 PM, Eryu Guan wrote:

...

> There's trailing whitespaces issue here, otherwise looks good to me.
> 
> I suppose the seq number can be fixed at commit time, as well as the
> trailing whitespaces.
> 
> Reviewed-by: Eryu Guan <eguan@redhat.com>
> 
> Thanks!
> Eryu
> 
> BTW, test fails on 3.12-rc5 kernel

Yup.  (actually it's a userspace bug)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
