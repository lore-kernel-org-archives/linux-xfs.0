Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KK4ZKZ080771 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:04:35 -0500
Subject: Re: [PATCH] mkfs.xfs: don't increase agblocks past maximum
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E78F184.2050404@redhat.com>
References: <4E77B7E2.6020805@redhat.com> <1316548828.2912.48.camel@doink>
	<4E78F184.2050404@redhat.com>
Date: Tue, 20 Sep 2011 15:04:31 -0500
Message-ID: <1316549071.2912.49.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, 2011-09-20 at 15:03 -0500, Eric Sandeen wrote:
> Yes, that's probably better.  More code change ... making it more
> readable.
> 
> I'll check it in that way (or, maybe you can, since I can't reach the
> git repo)? 

OK, I will check it into oss.sgi.com using the code
the way I suggested.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
