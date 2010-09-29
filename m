Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T0RE70008244
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 19:27:15 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E855AE901
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:28:13 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	sW2BfCCemWmGTeEP for <linux-xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 17:28:13 -0700 (PDT)
Received: by iwn39 with SMTP id 39so279241iwn.26
	for <linux-xfs@oss.sgi.com>; Tue, 28 Sep 2010 17:28:12 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Sep 2010 08:28:08 +0800
Message-ID: <AANLkTikd2Gf-=jimO-OvKb-66UquPkjfCN=+bx-3fhY-@mail.gmail.com>
Subject: how to increase speed to iterate all file's name in a XFS , about
	million files.
From: hank peng <pengxihan@gmail.com>
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
To: linux-xfs@oss.sgi.com

Hi:
I have a XFS file system which contains about million files in it. I
want to iterate all file's name using readdir function and I found
that a little time-consuming.
Anybody to suggest a way to increase its speed?

-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
