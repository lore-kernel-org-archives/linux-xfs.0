Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2F5C3803D
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 03:03:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F01A304043
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 01:03:51 -0800 (PST)
Received: from mail-pb0-f48.google.com (mail-pb0-f48.google.com
	[209.85.160.48]) by cuda.sgi.com with ESMTP id Zq9bibIHXe1OeHqx
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Mar 2013 01:03:49 -0800 (PST)
Received: by mail-pb0-f48.google.com with SMTP id wy12so2946456pbc.21
	for <xfs@oss.sgi.com>; Mon, 04 Mar 2013 01:03:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130301205305.GD23616@dastard>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<20130301111701.GB23616@dastard>
	<CANU9nTkkEd61UsM+KngGzMzXVXdOa2oXOPtmqN4xGaPuEBN_nQ@mail.gmail.com>
	<20130301205305.GD23616@dastard>
From: Ole Tange <tange@binf.ku.dk>
Date: Mon, 4 Mar 2013 10:03:29 +0100
Message-ID: <CANU9nTmmw3FcHRBNvu_S6Uj8M-B2JFf5poQfHbZuCbJ6_=_RgA@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 1, 2013 at 9:53 PM, Dave Chinner <david@fromorbit.com> wrote:
:
> What filesystem errors occurred
> when the srives went offline?

See http://dna.ku.dk/~tange/tmp/syslog.3

Feb 26 00:46:52 franklin kernel: [556238.429259] XFS (md5p1): metadata
I/O error: block 0x459b8 ("xfs_buf_iodone_callbacks") error 5 buf
count 4096


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
