Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NM4odp151266 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 17:04:55 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A8B71757E1B
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 15:05:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4LKJHayX1tqgEaTb for
	<xfs@oss.sgi.com>; Mon, 23 Aug 2010 15:05:23 -0700 (PDT)
Message-ID: <4C72F09D.5010006@redhat.com>
Date: Mon, 23 Aug 2010 17:05:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [ANNOUNCE] updated xfs documentation available
References: <4C72A04F.20104@redhat.com>
	<F57F2AD357626644AF76410876025D75529953@CGYEX705.encana.com>
In-Reply-To: <F57F2AD357626644AF76410876025D75529953@CGYEX705.encana.com>
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
To: "Kinzel, David" <David.Kinzel@encana.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Kinzel, David wrote:
>> Just as an FYI, we've converted some of the older SGI XFS documentation
>> to XML/Docbook/Publican[1] format, and it's now available on 
>> xfs.org; see
>> http://xfs.org/index.php/XFS_Papers_and_Documentation
>>
>> particularly the 3 links at the top, 
>>
>>    * XFS User Guide 
>>
>>    * XFS File System Structure 
>>
> 
> I am not sure about the other guides, but the images in the html output
> are being sized down making them not-so-readable. Eg,
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/
> html/Internal_Inodes.html
> 
> Would it be possible to regenerate these with the scaling off?
> 
> Thanks,

Interesting, I'll have to look into how publican decides to scale images
when it generates html... not sure offhand.  :)

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
