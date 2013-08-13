Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FA667F37
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 11:59:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C471CAC001
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 09:59:57 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id 3aJ4xYh4TpWCqQ6N (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 09:59:56 -0700 (PDT)
Message-ID: <520A6607.7060002@infradead.org>
Date: Tue, 13 Aug 2013 09:59:51 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
Subject: Re: linux-next: Tree for Aug 13 (xfs)
References: <20130813182832.16d18ef3dbc267c1a229bcd6@canb.auug.org.au>
In-Reply-To: <20130813182832.16d18ef3dbc267c1a229bcd6@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On 08/13/13 01:28, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130812:
> 

on i386:

fs/built-in.o: In function `xfs_log_calc_minimum_size':
(.text+0x1797a9): undefined reference to `__udivdi3'


-- 
~Randy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
