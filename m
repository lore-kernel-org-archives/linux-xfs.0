Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q367BlDb139996 for <xfs@oss.sgi.com>; Fri, 6 Apr 2012 02:11:47 -0500
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id 7fTFaMCH0I3xw2KH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 06 Apr 2012 00:11:45 -0700 (PDT)
Received: by yhjj72 with SMTP id j72so1567141yhj.26
	for <xfs@oss.sgi.com>; Fri, 06 Apr 2012 00:11:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8544B101-3848-428A-BB7E-C91CE897163B@filmlight.ltd.uk>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<8544B101-3848-428A-BB7E-C91CE897163B@filmlight.ltd.uk>
Date: Fri, 6 Apr 2012 09:11:44 +0200
Message-ID: <CAAxjCEz6=n3XWML7WtAOAE2KfCTR=LZi78B=dbSP4h0MngK1hA@mail.gmail.com>
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
From: Stefan Ring <stefanrin@gmail.com>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On Fri, Apr 6, 2012 at 12:32 AM, Roger Willcocks <roger@filmlight.ltd.uk> wrote:
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide/tmp/en-US/html/ch06s10.html

This sounds like it could help very much. I'll try that. Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
