Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3982C7F3F
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 10:47:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7EA4AC001
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 08:47:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IRg5GkeiMilXPEQo for <xfs@oss.sgi.com>;
	Mon, 09 Mar 2015 08:47:46 -0700 (PDT)
Received: from Liberator.local (unknown [40.139.179.11])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id F231F620CF34
	for <xfs@oss.sgi.com>; Mon,  9 Mar 2015 10:47:45 -0500 (CDT)
Message-ID: <54FDC0A0.10907@sandeen.net>
Date: Mon, 09 Mar 2015 11:47:44 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfsprogs: xfs_db: add crc manipulation commands
References: <540B4399.4020804@sandeen.net> <540B49DF.8000404@sandeen.net>
In-Reply-To: <540B49DF.8000404@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

On 9/6/14 1:52 PM, Eric Sandeen wrote:
> This adds a new "crc" command to xfs_db for CRC-enabled filesystems.

Actually, with my other patch to allow "corrupt" writes from xfs_db,
maybe a dedicated "crc" command isn't needed.  What do folks think?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
