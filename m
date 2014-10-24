Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 924A77F6D
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 10:48:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F86F8F8039
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 08:48:57 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id F4fMrUpswgyaFVwj for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 08:48:56 -0700 (PDT)
Message-ID: <544A74E7.1060502@sandeen.net>
Date: Fri, 24 Oct 2014 10:48:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: enable sparse checking
References: <54498F4A.9030207@redhat.com>
	<20141024061718.GA15341@infradead.org>
	<544A59F7.4070601@sandeen.net>
	<20141024154058.GA10788@infradead.org>
In-Reply-To: <20141024154058.GA10788@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/24/14 10:40 AM, Christoph Hellwig wrote:
> strong opinion.  It's not like your patch prevents me from using CC=cgcc

To get endian checking with your method, you'd need to edit
the Makefile to add the -D define, right?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
