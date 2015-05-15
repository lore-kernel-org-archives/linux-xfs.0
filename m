Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3BA7E7F37
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 15:58:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BC1BFAC005
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 13:58:39 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id jKmndaQDZxkNlpBB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 13:58:34 -0700 (PDT)
Date: Fri, 15 May 2015 13:58:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Let's get a File & Storage miniconf going at LPC2015!
Message-ID: <20150515205825.GC24967@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi again,

Early registration for this summer's Plumbers in Seattle, Washington ends
next Friday the 22nd.  With that in mind, I still don't have quite enough
people listed on the File & Storage miniconf wiki page for the organizers
to declare us an official miniconference, so if you're planning to go, or
even think you might go, please take a look at the planning page[1] and
add your name!

At a bare minimum, it seems like we can continue the ongoing discussions
around SMR exploration; the work going on with persistent memory and how to
expose it to filesystems and user apps; I see a proposal for the refereed
talks about the ongoing Open SSD work; and there have been prompts for more
conversation about rich ACL integration and supporting RDMA in NFS and Samba.
I think it would also be a good place to talk more about how to better
accomodate userspace filesystems like Ceph, giving things like the recent
O_NOMTIME thread, and other things like copy_file_range().

We of course are not limited to just those topics -- if there's something
you'd really like to discuss with everyone, please add that to the wiki.
I realize that mid-August is family vacation time for many people, but
those are the constraints the conference has to work with this year.
There are fun things to do around Seattle, and that's probably the best
time of year to visit.

--Darrick

[1] http://wiki.linuxplumbersconf.org/2015:file_and_storage_systems

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
