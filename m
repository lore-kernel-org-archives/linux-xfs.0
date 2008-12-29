Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTNXpC0008303 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 17:33:52 -0600
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 414F71794832
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 15:33:49 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com
	[208.42.117.202]) by cuda.sgi.com with ESMTP id
	qHTCRGv4ZFrAA0LX for <xfs@oss.sgi.com>;
	Mon, 29 Dec 2008 15:33:49 -0800 (PST)
Received: from funky.thebarn.com (slurp.thebarn.com [208.42.117.201])
	(authenticated bits=0)
	by slurp.thebarn.com (8.14.0/8.14.0) with ESMTP id mBTN4OEA081742
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 17:04:25 -0600 (CST)
	(envelope-from cattelan@thebarn.com)
Message-ID: <49595778.6000200@thebarn.com>
Date: Mon, 29 Dec 2008 17:04:24 -0600
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: xfs-cmds git tree re-imported
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

Based on Christoph's work to the xfs-authors list and his fix to cvsps
that can now accurately detect ptools changes sets the xfs-cmds tree
has been re-imported to git.

Please see for more info on the git trees in general.
http://xfs.org/index.php/Getting_the_latest_source_code

Note a new clone of the xfs-cmds tree  is required since this is a fresh 
import
and does not share any commit data with the old import of xfs-cmds.

The xfs-import and dmapi-import trees have also been re-imported.
These trees are not build able  trees but are good reference sources as
they have much of the xfs history.

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-import/.git;a=summary
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/dmapi-import/.git;a=summary

-Russell

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
