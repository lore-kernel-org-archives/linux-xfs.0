Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B72D7F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 04:13:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5876AC007
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 02:12:56 -0700 (PDT)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	iRuAvJZ96N5L9QwJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 02:12:55 -0700 (PDT)
Received: by lbbk10 with SMTP id k10so12233480lbb.0
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 02:12:53 -0700 (PDT)
Subject: Re: [PATCH] xfsprogs: make platform_defs.h more friendly to C++ code
References: <1444726778-11867-1-git-send-email-avi@scylladb.com>
	<20151013090636.GA15024@infradead.org>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <561CCB13.8040902@scylladb.com>
Date: Tue, 13 Oct 2015 12:12:51 +0300
MIME-Version: 1.0
In-Reply-To: <20151013090636.GA15024@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 10/13/2015 12:06 PM, Christoph Hellwig wrote:
> Hi Avi,
>
> in xfsprogs 4.2 platform_defs.h does not get installed and is purely
> internal to xfsprogs, so this shouldn't be needed.

Cool, ignore this then.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
