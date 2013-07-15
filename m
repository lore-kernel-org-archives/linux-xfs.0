Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B27BD7F37
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 16:22:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 968B6304043
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 14:22:50 -0700 (PDT)
Received: from mail-qe0-f45.google.com (mail-qe0-f45.google.com
	[209.85.128.45]) by cuda.sgi.com with ESMTP id DmUHKtIZfVVdJrvM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Jul 2013 14:22:49 -0700 (PDT)
Received: by mail-qe0-f45.google.com with SMTP id w7so6794797qeb.18
	for <xfs@oss.sgi.com>; Mon, 15 Jul 2013 14:22:49 -0700 (PDT)
Message-ID: <51E46826.20709@gmail.com>
Date: Mon, 15 Jul 2013 17:22:46 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
Subject: Re: Linux Plumbers IO & File System Micro-conference
References: <51E03AFB.1000000@gmail.com>
	<F0897B83F4BC10458936F08DADF233160F65F99416@MX02A.corp.emc.com>
In-Reply-To: <F0897B83F4BC10458936F08DADF233160F65F99416@MX02A.corp.emc.com>
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
To: "faibish, sorin" <faibish_sorin@emc.com>
Cc: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "anaconda-devel-list@redhat.com" <anaconda-devel-list@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On 07/12/2013 01:42 PM, faibish, sorin wrote:
> Can we have a discussion on Lustre client in the kernel? Thanks
>
> ./Sorin

I am not sure that we have that much to do for Lustre on the client side. Is 
this a topic that would be of broad enough interest to include people outside of 
the kernel developers?

thanks!

Ric

>
> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On Behalf Of Ric Wheeler
> Sent: Friday, July 12, 2013 1:21 PM
> To: linux-scsi@vger.kernel.org; Linux FS Devel; linux-nfs@vger.kernel.org; linux-btrfs; xfs-oss; linux-ext4@vger.kernel.org; device-mapper development; IDE/ATA development list; anaconda-devel-list@redhat.com
> Subject: Linux Plumbers IO & File System Micro-conference
>
>
> Linux Plumbers has approved a file and storage microconference. The overview page is here:
>
> http://wiki.linuxplumbersconf.org/2013:file_and_storage_systems
>
> I would like to started gathering in ideas for topics. I have been approached already with a request to cover the copy_range work Zach Brown kicked off at LSF which I think is a great topic since it has impact throughout the stack, all the way up to applications programmers.
>
> A similar request was made to give some time to non-volatile memory devices and the proposed "persistent memory" backed block device and persistent memory file system from Intel. That also seems to fall in nicely with the plumbers mission statement since it clearly will impact everything from the application on down through the kernel.
>
> Last year, we had a good discussion on management of storage (anaconda, yast, libstoragemgt, etc) - that also might be worth giving updates on.
>
> The instructions for submitting ideas will be updated later today at:
>
> http://www.linuxplumbersconf.org/2013/submitting-topic/
>
> If you have topics that you would like to add, wait until the instructions get posted at the link above. If you are impatient, feel free to email me directly (but probably best to drop the broad mailing lists from the reply).
>
> Thanks!
>
> Ric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
