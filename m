Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CCBB57CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 02:27:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D69B8F8039
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:27:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id m0QdnE0Bgh3TdaHE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:27:37 -0700 (PDT)
Date: Mon, 21 Mar 2016 15:27:35 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: obtaining xfstests repository
Message-ID: <20160321072735.GB11419@eguan.usersys.redhat.com>
References: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
	<20160321063848.GK11812@dastard>
	<CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
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

On Mon, Mar 21, 2016 at 08:22:09AM +0100, Sonia mandelbrott wrote:
> Thank you for your replies, here is output when used your link:
> 
> -bash-4.2$ git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> Cloning into 'xfstests-dev'...
> fatal: unable to connect to git.kernel.org:
> git.kernel.org[0: 149.20.4.72]: errno=Connection timed out
> git.kernel.org[1: 199.204.44.194]: errno=Connection timed out
> git.kernel.org[2: 198.145.20.140]: errno=Connection timed out
> git.kernel.org[3: 2620:3:c000:a:0:1991:8:25]: errno=Network is unreachable
> git.kernel.org[4: 2001:4f8:1:10:0:1991:8:25]: errno=Network is unreachable

I have no problem cloning both repos, perhaps something went wrong with
your network connection?

Thanks,
Eryu

> 
> On Mon, Mar 21, 2016 at 7:38 AM, Dave Chinner <david@fromorbit.com> wrote:
> 
>     On Mon, Mar 21, 2016 at 05:57:39AM +0100, Sonia mandelbrott wrote:
>     > Hi. This might sound stupid to you, but I have gotproblem with obtaining
>     > xfstests repo.
>     > When I try git clone git://oss.sgi.com/xfs/cmds/xfstests
>     > I get timeout after several minutes. I think it is problem with ssh keys?
>     > Can You possibly guide me step by step what I need to do?
>     > Sorry for all the trouble,
> 
>     Just use this repository:
> 
>     git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
>     Cheers,
> 
>     Dave.
>     --
>     Dave Chinner
>     david@fromorbit.com
> 

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
