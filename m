Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NM2jlT151198 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 17:02:46 -0500
Received: from CGYSNEX001.encana.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA054D15B5C
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 15:13:04 -0700 (PDT)
Received: from CGYSNEX001.encana.com (cgysnex001.encana.com [142.56.87.68]) by
	cuda.sgi.com with ESMTP id AsHi1FoVBC3LnW8s for
	<xfs@oss.sgi.com>; Mon, 23 Aug 2010 15:13:04 -0700 (PDT)
Received: from CGYEX203.encana.com (unverified) by CGYSNEX001.encana.com
	(Clearswift SMTPRS 5.3.2) with ESMTP id
	<T97ac193b688e3857441690@CGYSNEX001.encana.com> for <xfs@oss.sgi.com>;
	Mon, 23 Aug 2010 16:03:16 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [ANNOUNCE] updated xfs documentation available
Date: Mon, 23 Aug 2010 16:03:14 -0600
Message-ID: <F57F2AD357626644AF76410876025D75529953@CGYEX705.encana.com>
In-Reply-To: <4C72A04F.20104@redhat.com>
References: <4C72A04F.20104@redhat.com>
From: "Kinzel, David" <David.Kinzel@encana.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

>Just as an FYI, we've converted some of the older SGI XFS documentation
>to XML/Docbook/Publican[1] format, and it's now available on 
>xfs.org; see
>http://xfs.org/index.php/XFS_Papers_and_Documentation
>
>particularly the 3 links at the top, 
>
>    * XFS User Guide 
>
>    * XFS File System Structure 
>

I am not sure about the other guides, but the images in the html output
are being sized down making them not-so-readable. Eg,
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/
html/Internal_Inodes.html

Would it be possible to regenerate these with the scaling off?

Thanks,

>    * XFS Training Labs 
>
>In addition to the XML conversion, much of the documentation has
>been updated & corrected compared to the original docs.
>
>This should be good material for anyone using, developing, or 
>supporting
>XFS.  If omissions or errors are found, we'd be happy to accept
>patches against the XML source for the docs, found at
>http://git.kernel.org/?p=fs/xfs/xfsdocs-xml-dev.git;a=summary
>
>In addition, using that git repo + publican allows one to create
>the documentation in various other forms such as PDFs, txt,
>and epub.
>
>Thanks!
>
>-Eric
>
>[1] https://fedorahosted.org/publican/

This email communication and any files transmitted with it may contain confidential and or proprietary information and is provided for the use of the intended recipient only.  Any review, retransmission or dissemination of this information by anyone other than the intended recipient is prohibited.  If you receive this email in error, please contact the sender and delete this communication and any copies immediately.  Thank you.
http://www.encana.com



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
