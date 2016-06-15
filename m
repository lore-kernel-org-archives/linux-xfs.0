Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6BC57CA0
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 02:00:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E14AAC003
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 00:00:12 -0700 (PDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id 0GPClhMDIkEb8hMa
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jun 2016 00:00:09 -0700 (PDT)
Received: by mail-wm0-f45.google.com with SMTP id v199so149439857wmv.0
	for <xfs@oss.sgi.com>; Wed, 15 Jun 2016 00:00:09 -0700 (PDT)
Subject: Re: Something badly broken with the latest XFS changeset in all
	stable kernels?
References: <75808782-835f-4bc9-5243-b25cab00d6f3@whissi.de>
	<20160615000241.GC26977@dastard> <20160615013056.GA23074@kroah.com>
	<20160615052831.GA3452@1wt.eu>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <ab3877db-6c0c-545f-766c-5ba5d00b5ab9@suse.cz>
Date: Wed, 15 Jun 2016 09:00:06 +0200
MIME-Version: 1.0
In-Reply-To: <20160615052831.GA3452@1wt.eu>
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
To: Willy Tarreau <w@1wt.eu>, Greg KH <greg@kroah.com>
Cc: "Thomas D." <whissi@whissi.de>, spender@grsecurity.net, stable@vger.kernel.org, xfs@oss.sgi.com

On 06/15/2016, 07:28 AM, Willy Tarreau wrote:
> Jiri has queued it for 3.12 but not yet released it.

Fixed now, thanks!

-- 
js
suse labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
