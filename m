Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3FB347CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 01:39:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3084AC002
	for <xfs@oss.sgi.com>; Sun, 20 Mar 2016 23:39:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NVIOE8RWQEYoxsBr for <xfs@oss.sgi.com>;
	Sun, 20 Mar 2016 23:39:11 -0700 (PDT)
Date: Mon, 21 Mar 2016 17:38:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: obtaining xfstests repository
Message-ID: <20160321063848.GK11812@dastard>
References: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
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
To: Sonia mandelbrott <sonia.mandelbrott@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 21, 2016 at 05:57:39AM +0100, Sonia mandelbrott wrote:
> Hi. This might sound stupid to you, but I have gotproblem with obtaining
> xfstests repo.
> When I try git clone git://oss.sgi.com/xfs/cmds/xfstests
> I get timeout after several minutes. I think it is problem with ssh keys?
> Can You possibly guide me step by step what I need to do?
> Sorry for all the trouble,

Just use this repository:

git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
