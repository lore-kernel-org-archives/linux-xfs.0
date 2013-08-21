Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D21B7F9A
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 15:06:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38EB78F8040
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 13:06:14 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id YVu4si9D7MzXHja4 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Aug 2013 13:06:13 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] powerpc/spufs: convert userns uid/gid mount options to
	kuid/kgid
Date: Wed, 21 Aug 2013 22:05:27 +0200
References: <20130820172052.1f0d89ddf6a1a40ef70333fd@canb.auug.org.au>
	<20130821155654.GI5262@sgi.com>
	<20130821143351.5840d556@oracle.com>
In-Reply-To: <20130821143351.5840d556@oracle.com>
MIME-Version: 1.0
Message-Id: <201308212205.27789.arnd@arndb.de>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: cbe-oss-dev@lists.ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, linux-next@vger.kernel.org, Jeremy Kerr <jk@ozlabs.org>, linuxppc-dev@lists.ozlabs.org, Gao feng <gaofeng@cn.fujitsu.com>

On Wednesday 21 August 2013, Dwight Engen wrote:
> 
> Acked-by: Jeremy Kerr <jk@ozlabs.org>
> Tested-by: Jeremy Kerr <jk@ozlabs.org>
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
