Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NGMBXQ137812 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 11:22:11 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE2741758D5D
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 09:22:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1Kuxutyx1iEnFI1D for
	<xfs@oss.sgi.com>; Mon, 23 Aug 2010 09:22:43 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7NGMgFL010142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 12:22:42 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o7NGMdNC030391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 12:22:42 -0400
Message-ID: <4C72A04F.20104@redhat.com>
Date: Mon, 23 Aug 2010 11:22:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [ANNOUNCE] updated xfs documentation available
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
To: xfs-oss <xfs@oss.sgi.com>

Just as an FYI, we've converted some of the older SGI XFS documentation
to XML/Docbook/Publican[1] format, and it's now available on xfs.org; see
http://xfs.org/index.php/XFS_Papers_and_Documentation

particularly the 3 links at the top, 

    * XFS User Guide 

    * XFS File System Structure 

    * XFS Training Labs 

In addition to the XML conversion, much of the documentation has
been updated & corrected compared to the original docs.

This should be good material for anyone using, developing, or supporting
XFS.  If omissions or errors are found, we'd be happy to accept
patches against the XML source for the docs, found at
http://git.kernel.org/?p=fs/xfs/xfsdocs-xml-dev.git;a=summary

In addition, using that git repo + publican allows one to create
the documentation in various other forms such as PDFs, txt,
and epub.

Thanks!

-Eric

[1] https://fedorahosted.org/publican/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
