Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 94A667F37
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 12:21:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83C2F304053
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 10:21:03 -0700 (PDT)
Received: from mail-ie0-f182.google.com (mail-ie0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	2ftcR0Vmg5z3BSw0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 12 Jul 2013 10:21:02 -0700 (PDT)
Received: by mail-ie0-f182.google.com with SMTP id s9so21414621iec.27
	for <xfs@oss.sgi.com>; Fri, 12 Jul 2013 10:21:02 -0700 (PDT)
Message-ID: <51E03AFB.1000000@gmail.com>
Date: Fri, 12 Jul 2013 13:20:59 -0400
From: Ric Wheeler <ricwheeler@gmail.com>
MIME-Version: 1.0
Subject: Linux Plumbers IO & File System Micro-conference
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
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, anaconda-devel-list@redhat.com


Linux Plumbers has approved a file and storage microconference. The overview 
page is here:

http://wiki.linuxplumbersconf.org/2013:file_and_storage_systems

I would like to started gathering in ideas for topics. I have been approached 
already with a request to cover the copy_range work Zach Brown kicked off at LSF 
which I think is a great topic since it has impact throughout the stack, all the 
way up to applications programmers.

A similar request was made to give some time to non-volatile memory devices and 
the proposed "persistent memory" backed block device and persistent memory file 
system from Intel. That also seems to fall in nicely with the plumbers mission 
statement since it clearly will impact everything from the application on down 
through the kernel.

Last year, we had a good discussion on management of storage (anaconda, yast, 
libstoragemgt, etc) - that also might be worth giving updates on.

The instructions for submitting ideas will be updated later today at:

http://www.linuxplumbersconf.org/2013/submitting-topic/

If you have topics that you would like to add, wait until the instructions get 
posted at the link above. If you are impatient, feel free to email me directly 
(but probably best to drop the broad mailing lists from the reply).

Thanks!

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
