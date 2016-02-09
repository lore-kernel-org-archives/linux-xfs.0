Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5BE857CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 18:41:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 472AA304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 16:41:07 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id cQ6PA9oaFaC8z6tx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 16:41:04 -0800 (PST)
Date: Tue, 9 Feb 2016 11:41:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-ID: <20160209114102.118fdc02@canb.auug.org.au>
In-Reply-To: <56B93330.20608@sandeen.net>
References: <20160209111721.359f8558@canb.auug.org.au>
	<56B93330.20608@sandeen.net>
MIME-Version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Eric,

On Mon, 8 Feb 2016 18:30:40 -0600 Eric Sandeen <sandeen@sandeen.net> wrote:
>
> Dave just sent a patch to the xfs list to fix this,
> 
> [PATCH] xfs: log recovery needs to be aware of CONFIG_XFS_RT now

Thanks.  Hopefully it will be fixed in the xfs tree for linux-next
tomorrow, then,

-- 
Cheers,
Stephen Rothwell

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
