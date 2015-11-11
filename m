Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0C0AD7F5E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 06:50:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFA6B8F804B
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 04:50:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CB2kkshCrc0zH7HU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 04:50:25 -0800 (PST)
Date: Wed, 11 Nov 2015 13:50:22 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfsprogs install
Message-ID: <20151111125021.GA28745@redhat.com>
References: <CAFf1yNFYh3C9NR8OadL=wXALT3mj58LTVvnE3fypOBXOP_JzoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFf1yNFYh3C9NR8OadL=wXALT3mj58LTVvnE3fypOBXOP_JzoQ@mail.gmail.com>
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
To: rui li <liruilong0128@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 11, 2015 at 02:38:24PM +0800, rui li wrote:
>    hello
>    when i install xfsprogs i hava follwing problems
>    FATAL ERROR: could not find a valid BLKID header
>    Install the Block device ID development package
>    could you give me some help?
>    thanks
install libblkid-devel package in your distribution, or any similar package that
your distribution provides with libblkid headers.


> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
