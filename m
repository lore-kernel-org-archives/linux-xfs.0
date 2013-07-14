Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 310D97F37
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 14:52:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B2B98AC002
	for <xfs@oss.sgi.com>; Sun, 14 Jul 2013 12:52:51 -0700 (PDT)
Received: from smtp3.clear.net.nz (smtp3.clear.net.nz [203.97.33.64]) by
	cuda.sgi.com with ESMTP id aYNm2nTrfzzmUzuW for
	<xfs@oss.sgi.com>; Sun, 14 Jul 2013 12:52:47 -0700 (PDT)
Received: from mxin3-orange.clear.net.nz
	(lb2-srcnat.clear.net.nz [203.97.32.237])
	by smtp3.clear.net.nz (CLEAR Net Mail)
	with ESMTP id <0MPX000I8Z7XHF00@smtp3.clear.net.nz> for xfs@oss.sgi.com;
	Mon, 15 Jul 2013 07:52:45 +1200 (NZST)
Date: Mon, 15 Jul 2013 07:45:29 +1200
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: specify agsize?
Message-id: <51E2FFD9.6050703@clear.net.nz>
MIME-version: 1.0
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
To: xfs@oss.sgi.com

aurfalien wrote:
.............

So I would like to mess around and iozone any diffs between the above 
agcount of 32 and whatever agcount changes I may do.

.............

There is an Autodesk tool to do this work, sw_io_perf_tool which will 
give a much more realistic evaluation than iozone.

Checkout:

http://usa.autodesk.com/adsk/servlet/ps/dl/item?siteID=123112&id=15486735&linkID=9242618

Regards,

Richard

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
