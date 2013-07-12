Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC1AA7F37
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 12:42:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9764FAC003
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 10:42:47 -0700 (PDT)
Received: from mexforward.lss.emc.com (hop-nat-141.emc.com [168.159.213.141])
	by cuda.sgi.com with ESMTP id ty3iam87Rzp6yPQh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 10:42:46 -0700 (PDT)
From: "faibish, sorin" <faibish_sorin@emc.com>
Date: Fri, 12 Jul 2013 13:42:21 -0400
Subject: RE: Linux Plumbers IO & File System Micro-conference
Message-ID: <F0897B83F4BC10458936F08DADF233160F65F99416@MX02A.corp.emc.com>
References: <51E03AFB.1000000@gmail.com>
In-Reply-To: <51E03AFB.1000000@gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Ric Wheeler <ricwheeler@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, "anaconda-devel-list@redhat.com" <anaconda-devel-list@redhat.com>

Can we have a discussion on Lustre client in the kernel? Thanks

./Sorin

-----Original Message-----
From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On Behalf Of Ric Wheeler
Sent: Friday, July 12, 2013 1:21 PM
To: linux-scsi@vger.kernel.org; Linux FS Devel; linux-nfs@vger.kernel.org; linux-btrfs; xfs-oss; linux-ext4@vger.kernel.org; device-mapper development; IDE/ATA development list; anaconda-devel-list@redhat.com
Subject: Linux Plumbers IO & File System Micro-conference


Linux Plumbers has approved a file and storage microconference. The overview page is here:

http://wiki.linuxplumbersconf.org/2013:file_and_storage_systems

I would like to started gathering in ideas for topics. I have been approached already with a request to cover the copy_range work Zach Brown kicked off at LSF which I think is a great topic since it has impact throughout the stack, all the way up to applications programmers.

A similar request was made to give some time to non-volatile memory devices and the proposed "persistent memory" backed block device and persistent memory file system from Intel. That also seems to fall in nicely with the plumbers mission statement since it clearly will impact everything from the application on down through the kernel.

Last year, we had a good discussion on management of storage (anaconda, yast, libstoragemgt, etc) - that also might be worth giving updates on.

The instructions for submitting ideas will be updated later today at:

http://www.linuxplumbersconf.org/2013/submitting-topic/

If you have topics that you would like to add, wait until the instructions get posted at the link above. If you are impatient, feel free to email me directly (but probably best to drop the broad mailing lists from the reply).

Thanks!

Ric

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
